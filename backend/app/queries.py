from collections import defaultdict, deque
from fastapi import HTTPException

import psycopg2

from app.config import DATABASE_CONFIG

# Подключение к базе данных
def set_connection():
    try:
        conn = psycopg2.connect(f'postgresql://{DATABASE_CONFIG["user"]}:{DATABASE_CONFIG["password"]}@postgres:5432/{DATABASE_CONFIG["dbname"]}')
    except Exception as e:
        print(f"Failed to connect to the database: {e}")
        conn = None
    # Создаём курсор для работы с БД
    # cursor = conn.cursor() if conn else None
    return  conn

def auth_sql_query(login: str):
    conn = set_connection()
    with conn.cursor() as curs:
        # Ищем запись в БД с логином который передают
        curs.execute("SELECT id,password FROM users WHERE login = %s", (login,))
        user = curs.fetchone()
    conn.close()
    return user

def check_auth_sql_query(user_id: int):
    conn = set_connection()
    with conn.cursor() as curs:
        # Выполняем запрос, чтобы проверить существование пользователя
        curs.execute("SELECT id FROM users WHERE id = %s", (user_id,))
        user = curs.fetchone()
    conn.close()
    return user


def get_rooms_sql_query(query: str):
    conn = set_connection()
    with conn.cursor() as curs:
        # Выполняем запрос на основе наличия параметра query
        if query:
            curs.execute("SELECT name, floor, id, map_points FROM rooms WHERE name LIKE %s", (query,))
        else:
            curs.execute("SELECT name, floor, id, map_points FROM rooms")
        rooms = curs.fetchall()
    conn.close()
    return rooms

def get_rooms_point(start: int, end: int):
    conn = set_connection()
    with conn.cursor() as curs:
        curs.execute("SELECT id_route_point FROM rooms WHERE id IN (%s, %s)",(start, end))
        rooms_point_id = curs.fetchall()
    (point_id_r1, point_id_r2) = int(rooms_point_id[0][0]), int(rooms_point_id[1][0])
    graph_data = get_graph_data(conn)
    routes_list_id = bfs(graph_data, point_id_r1, point_id_r2)
    routes_list = []
    print(routes_list_id)
    with conn.cursor() as curs:
        for item in routes_list_id:
            query = f"SELECT points FROM route_points WHERE id =({item})"
            # Выполняем запрос с распакованным списком
            curs.execute(query, item)
            routes_list.append(curs.fetchall()[0][0])
    conn.close()

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

    raise HTTPException(status_code=404, detail="Path not found")

def get_graph_data(conn):
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
