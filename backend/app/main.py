from fastapi import FastAPI, Request, Security, Depends, HTTPException, Body, Query
from fastapi.security import APIKeyHeader
import jwt
from jwt import InvalidTokenError

from app.config import JWT_SECRET
from app import queries


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
async def get_user_token(data = Body()):
    # Используем вынесенную функцию для выполнения SQL-запроса
    login = data["login"]
    password = data["password"]
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

# Получение аудиторий
@app.get("/rooms")
async def get_rooms_list(request: Request, token: str = Depends(check_access_token), query: str = Query(None)):
    if request.state.user:
        query_str = f"%{query}%" if query else None
        rooms = queries.get_rooms_sql_query(query_str)

        rooms_list = []
        for room in rooms:
            bounds = room[3]

            bounds_items = []
            for item in bounds:
                bounds_items = list(map(int, item.split(",")))

            if bounds_items and len(bounds_items) % 2 == 0:
                bounds_pairs = [{"x": int(bounds_items[i]), "y": int(bounds_items[i + 1])} for i in
                                range(0, len(bounds_items), 2)]
            else:
                bounds_pairs = []
            
            rooms_list.append({
                "name": room[0],
                "floor": room[1],
                "id": room[2],
                "bounds": bounds_pairs
            })

        return {
            "message": "You have access!",
            "rooms": rooms_list,
            "user_id": request.state.user,
            "query": query,
        }
