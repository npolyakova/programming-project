from fastapi import FastAPI, Request, Security, Depends, HTTPException
from fastapi.security import APIKeyHeader
import psycopg2
import jwt
from jwt import InvalidTokenError

# Секретный ключ для JWT
JWT_SECRET = "1d354015d235d2691cbba0116754e68caa544f76a1e23221ded498c38ad0fb4e8e44f94fd600d8d0063c7f5e0852b83b83f494d663ea26e4e47574f3caa668803ec44dbcd978308b14798a5086a2e40dfc41d639695d0672bf31acd7f61023279951c53279e62985fdd37827f458ffbda32bd3e1015298738732e0c2c058821b05aa48f555b944afe73aafb6d348bf00720dec490a1ff62cbb61ed7c2e9e5150ce4cdc07b8c46bb3955b6d0e10e7b40efd199cf5639805ac0384065d9dfbede2e9af3d8ea5ec1ff9c5496136cd7ec44cf68dcd6ad4f66a04132cb82bc94c0514ebc9f85e4a57d3731471c1f917766bf964d360dc5c3990c97aa798e0f639b3b1"

# Подключение к базе данных
try:
    conn = psycopg2.connect(
        dbname='siriusproj',
        user='admin',
        password='yar123yar',
        host='127.0.0.1'
    )
except Exception as e:
    print('Can`t establish connection to database:', e)
    conn = None

# Создаём курсор для работы с БД
cursor = conn.cursor() if conn else None

# Middleware/зависимость для проверки токена
async def check_access_token(
    request: Request,
    authorization_header: str = Security(APIKeyHeader(name='Authorization', auto_error=False))
) -> str:
    # Проверяем, что токен передан
    if authorization_header is None:
        raise HTTPException()

    # Проверяем токен на соответствие форме
    if 'Bearer ' not in authorization_header:
        raise HTTPException()

    # Убираем лишнее из токена
    clear_token = authorization_header.replace('Bearer ', '')

    try:
        # Проверяем валидность токена
        payload = jwt.decode(clear_token, key=JWT_SECRET, algorithms='HS256')
    except InvalidTokenError:
        # В случае невалидности возвращаем ошибку
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user_id = payload.get('sub')
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid token payload")

    # Проверяем, существует ли пользователь
    with conn.cursor() as curs:
        curs.execute("SELECT id FROM users WHERE id = %s", (user_id,))
        user = curs.fetchone()

    if not user:
        raise HTTPException(status_code=401, detail="User not found")

    request.state.user = user[0]

    return authorization_header


# Создаём приложение FastAPI
app = FastAPI()

# Тестовый запуск
@app.get("/")
def read_root():
    return {"message": "Hello, FastAPI!"}

#Авторизация с генерацией токена и его возвратом
@app.post("/auth")
async def get_user_token(login: str):
    with conn.cursor() as curs:
    	# Ищем запись в БД с логином который передают
        curs.execute("SELECT id FROM users WHERE login = %s", (login,))
        user = curs.fetchone()

        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        user_id = user[0]
       	# Генерируем токен авторизации с передачей в него id пользователя
        token = jwt.encode({'sub': str(user_id)}, key=JWT_SECRET, algorithm='HS256')
        return {"message": "User token", "token": token}

# Пример запроса с проверкой токена
@app.get("/protected")
async def protected_route(request: Request, token: str = Depends(check_access_token)):
    return {"message": "You have access!", "user_id": request.state.user}
