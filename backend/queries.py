from config import DATABASE_CONFIG
from collections import defaultdict
from collections import deque
import psycopg2
# Подключение к базе данных
try:
    conn = psycopg2.connect(
        dbname=DATABASE_CONFIG["dbname"],
        user=DATABASE_CONFIG["user"],
        password=DATABASE_CONFIG["password"],
        host=DATABASE_CONFIG["host"],
    )
except Exception as e:
    print(f"Failed to connect to the database: {e}")
    conn = None

# Создаём курсор для работы с БД
cursor = conn.cursor() if conn else None

def auth_sql_query(login: str):
    with conn.cursor() as curs:
        # Ищем запись в БД с логином который передают
        curs.execute("SELECT id,password FROM users WHERE login = %s", (login,))
        user = curs.fetchone()
    return user

def check_auth_sql_query(user_id: int):
    with conn.cursor() as curs:
        # Выполняем запрос, чтобы проверить существование пользователя
        curs.execute("SELECT id FROM users WHERE id = %s", (user_id,))
        user = curs.fetchone()
    return user


def get_rooms_sql_query(query: str):
    with conn.cursor() as curs:
        # Выполняем запрос на основе наличия параметра query
        if query:
            curs.execute("SELECT name, floor, id, map_points FROM rooms WHERE name LIKE %s", (query,))
        else:
            curs.execute("SELECT name, floor, id, map_points FROM rooms")
        rooms = curs.fetchall()
    return rooms

def get_rooms_point(start: int, end: int):
    with conn.cursor() as curs:
        curs.execute("SELECT id_route_point FROM rooms WHERE id IN (%s, %s)",(start, end))
        rooms_point_id = curs.fetchall()
    (point_id_r1, point_id_r2) = rooms_point_id[0][0], rooms_point_id[1][0]
    graph_data = get_graph_data()
    routes_list_id =  bfs(graph_data, point_id_r1, point_id_r2)
    with conn.cursor() as curs:
        placeholders = ', '.join(['%s'] * len(routes_list_id))
        query = f"SELECT points FROM route_points WHERE id IN ({placeholders})"
        curs.execute(query, tuple(routes_list_id))
        routes_list = curs.fetchall()
    return routes_list

# BFS для поиска кратчайшего пути
def bfs(graph, start, end):
    queue = deque([[start]])
    visited = set()

    while queue:
        path = queue.popleft()
        node = path[-1]
        if node == end:
            return path
        if node not in visited:
            visited.add(node)
            for neighbor in graph.get(node, []):
                new_path = list(path)
                new_path.append(neighbor)
                queue.append(new_path)
    return None

def get_graph_data():
    graph = defaultdict(list)
    with conn.cursor() as curs:
        curs.execute("SELECT id, connected_points FROM route_points WHERE connected_points IS NOT NULL")
        for row in curs.fetchall():
            node_id = int(row[0])
            connections = row[1]
            if isinstance(connections, list):
                graph[node_id] = [int(conn) for conn in connections]
            else:
                connections_list = [int(float(x)) for x in connections.strip('{}').split(',')]
                graph[node_id] = connections_list
    return graph
