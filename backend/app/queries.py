import psycopg2

from app.config import DATABASE_CONFIG

# Подключение к базе данных
try:
    conn = psycopg2.connect(f'postgresql://{DATABASE_CONFIG["user"]}:{DATABASE_CONFIG["password"]}@postgres:5432/{DATABASE_CONFIG["dbname"]}')
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
