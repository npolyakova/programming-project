from fastapi import FastAPI, Request, Security, Depends, HTTPException, Query
from fastapi.security import APIKeyHeader
import psycopg2
import jwt
from jwt import InvalidTokenError
from config import DATABASE_CONFIG
from config import JWT_SECRET
import queries

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
    user = queries.check_auth_sql_query(user_id)

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
async def get_user_token(login: str, password: str):
    # Используем вынесенную функцию для выполнения SQL-запроса
    user = queries.auth_sql_query(login)

    if not user:
       raise HTTPException(status_code=404, detail="User not found")

    user_id, user_password = user
    # Проверяем пароль
    if(password !=user_password):
    	raise HTTPException(status_code=401, detail="Invalid password")
    
    # Генерируем токен авторизации
    token = jwt.encode({'sub': str(user_id)}, key=JWT_SECRET, algorithm='HS256')
    return {"message": "User token", "token": token}


# Пример запроса с проверкой токена
@app.get("/protected")
async def protected_route(request: Request, token: str = Depends(check_access_token)):
    return {"message": "You have access!", "user_id": request.state.user}
