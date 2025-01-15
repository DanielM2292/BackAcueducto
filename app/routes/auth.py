from flask import Blueprint, request, jsonify, current_app, render_template, redirect, url_for, session
from app.models import User, Auditoria
import os, hashlib

auth_bp = Blueprint('auth', __name__, url_prefix='/auth')

@auth_bp.route('/')
def main():
    return render_template('login.html')

@auth_bp.route('/test', methods=['GET'])
def test():
    return jsonify({'message': 'Endpoint de prueba funcionando!'}), 200

# Ruta en la cual se almacenaran los nombres de usuarios y contraseñas que se van agregarndo
ruta_archivo = os.path.join(os.getcwd(), 'data', 'contraseñas.txt')
# Enpoint para agregar usuario, se pasa los parametros con formato JSON
@auth_bp.route('/register', methods=['POST'])
def create_user():
    mysql = current_app.mysql
    
    custom_id = Auditoria.generate_custom_id(mysql, 'ADMI', 'id_administrador', 'administradores')
    custom_id_auditoria = Auditoria.generate_custom_id(mysql, 'AUDI', 'id_auditoria', 'auditoria')
    
    data = request.get_json()
    #id_user = data.get('id_user')
    user_name = data.get('user_name')
    user_username = data.get('user_username')
    user_password = data.get('user_password')
    estado_empleado = data.get('estado_empleado')
    id_rol = data.get('id_rol')

    # Si no digita los campos requeridos
    if not user_name or not user_password:
        return jsonify({'message': 'Se require ingresar usuario y contraseña'}), 400

    # Verificar si el nombre de usuario ya existe
    existing_user = User.get_user_by_username(mysql, user_username)
    
    if existing_user:
        return jsonify({'message': 'El usuario ya existe'}), 400

    User.add_user(mysql,custom_id, user_name, user_username, user_password, estado_empleado, id_rol)
    # Buscar como hacer que en el parametro del usuario pasarle el id del usuario que lo crea, aunque siempre va a crear los usuarios el administrador que es unico 
    Auditoria.registrar_auditoria(mysql, custom_id_auditoria, 'administradores', custom_id, 'INSERT', 'ADMI0003', 'Se crea usuario por primera vez' )
    with open(ruta_archivo, 'a') as f:
        f.write(f'Nombre de usuario: {user_username} - Contraseña: {user_password}\n')
    
    return jsonify({'message': 'Usuario creado!'}), 201
    
# Endpoint para validar usuario y contraseña
@auth_bp.route('/loginValidate', methods=['POST'])
def loginValidate():
    
    mysql = current_app.mysql
    
    data = request.get_json()
    username = data.get('user_username')
    password = data.get('user_password')

    if not username or not password:
        return jsonify({'message': 'Se requiere usuario y contraseña'}), 400

    user = User.get_user_by_username(mysql, username)
    if user and User.check_password(user['password'], password):
        
        return jsonify({'message': 'Login successful!'}), 200
    else:
        return jsonify({'message': 'Incorrect username or password!'}), 401

#Endpoint para actualizar el nombre de usuario
@auth_bp.route('/updateUser', methods=['POST'])
def updateUser():
    
    mysql = current_app.mysql
    
    data = request.get_json()
    user_usernameN = data.get('user_usernameN')
    user_username = data.get('user_username')
    
    User.update_user(mysql,user_usernameN, user_username)
    return jsonify({'message': 'Nombre de usuario actualizado'}), 200

@auth_bp.route('/login', methods=["POST"])
def login():
    if request.method == "POST":
        user = request.form["email"]
        password = request.form["password"]
        rol = request.form["rol"]
        #session crea una cokie en el navegador, diccionario session
        session['user'] = user
        session['password'] = password
        session['rol'] = rol
        # Esta redireccion la hace al metodo def index()
        return redirect(url_for('index'))
    else:
        return "error redireccion"

@auth_bp.route('/index')
def index():
    
    mysql = current_app.mysql
    
    if not session["user"] or not session["password"] or not session["rol"]:
        return redirect(url_for('main'))

    user = User.get_user_by_username(mysql, session["user"])
    if user['id_estado_empleado'] == 'EMPL0001':
        # user['password'] es la contraseña de la base de datos
        if user and User.check_password(user['password'], session["password"]):
            if user['id_rol'] == 'ROL0001' and session["rol"] == "administrador":
                return render_template('admin.html', user=user)
            elif user['id_rol'] == 'ROL0002' and session["rol"] == "auxiliar" :
                return render_template('auxiliar.html', user=user)
            elif user['id_rol'] == 'ROL0003' and session["rol"] == "contador":
                return render_template('contador.html', user=user)
        return redirect(url_for('main'))
    else:
        return redirect(url_for('main'))

ruta_archivo = os.path.join(os.getcwd(), 'data', 'contraseñas.txt')
@auth_bp.route('/changuePassword', methods=['POST'])
def changuePassword():
    
    mysql = current_app.mysql
    
    custom_id_auditoria = User.generate_custom_id(mysql, 'AUDI', 'id_auditoria', 'auditoria')
    
    if "user" not in session:
        return redirect(url_for('main'))
    
    password = request.form['password']
    new_password = request.form['new_password']
    
    user = User.get_user_by_username(mysql, session["user"])
    
    if user and User.check_password(user['password'], password):
        # Hashear la nueva contraseña
        hashed_password = hashlib.sha256(new_password.encode()).hexdigest()
        
        # Actualizar la contraseña en la base de datos
        cursor = mysql.connection.cursor()
        cursor.execute("UPDATE administradores SET password=%s WHERE nombre_usuario=%s",(hashed_password, session["user"])
        )
        mysql.connection.commit()
        cursor.close()

        print('Contraseña Actualizada')
        User.registrar_auditoria(mysql, custom_id_auditoria, 'administradores', user["id_administrador"], 'UPDATE', user["id_administrador"], 'Se actualiza la contraseña del usuario' )
        with open(ruta_archivo, 'a') as f:
            f.write(f'Nombre de usuario: {session["user"]} - Contraseña: {new_password}\n')
        return redirect(url_for('main'))
    else:
        print('Error al cambiar contraseña')
        return redirect(url_for('main'))

@auth_bp.route('/logout')  
def logout():
    # Se limpia la variable session del usuario que esta manejando y redirecciona al login
    session.clear()
    return redirect(url_for('main'))


# -----------------------------------------------------------------------------------------------


# from flask import Flask, request, render_template, redirect, url_for, session
# from config import Config
# import hashlib, os
# from flask_cors import CORS
# from models import init_db, get_user_by_username, check_password, generate_custom_id, registrar_auditoria

# # Crear la conexion con la base de datos y llama a la inicializacion en el archivo models
# app = Flask(__name__)
# # Esta clave la requiere session para que el pueda encriptar el inicio de sesion
# app.secret_key = "cualquier_clave"
# app.config.from_object(Config)
# mysql = init_db(app)
# CORS(app)

# @app.route('/')
# def main():
#     return render_template('login.html')

# @app.route('/login', methods=["POST"])
# def login():
#     if request.method == "POST":
#         user = request.form["email"]
#         password = request.form["password"]
#         rol = request.form["rol"]
#         #session crea una cokie en el navegador, diccionario session
#         session['user'] = user
#         session['password'] = password
#         session['rol'] = rol
#         # Esta redireccion la hace al metodo def index()
#         return redirect(url_for('index'))
#     else:
#         return "error redireccion"

# @app.route('/index')
# def index():
#     if not session["user"] or not session["password"] or not session["rol"]:
#         return redirect(url_for('main'))

#     user = get_user_by_username(mysql, session["user"])
#     if user['id_estado_empleado'] == 'EMPL0001':
#         # user['password'] es la contraseña de la base de datos
#         if user and check_password(user['password'], session["password"]):
#             if user['id_rol'] == 'ROL0001' and session["rol"] == "administrador":
#                 return render_template('admin.html', user=user)
#             elif user['id_rol'] == 'ROL0002' and session["rol"] == "auxiliar" :
#                 return render_template('auxiliar.html', user=user)
#             elif user['id_rol'] == 'ROL0003' and session["rol"] == "contador":
#                 return render_template('contador.html', user=user)
#         return redirect(url_for('main'))
#     else:
#         return redirect(url_for('main'))

# ruta_archivo = os.path.join(os.getcwd(), 'data', 'contraseñas.txt')
# @app.route('/changuePassword', methods=['POST'])
# def changuePassword():
    
#     custom_id_auditoria = generate_custom_id(mysql, 'AUDI', 'id_auditoria', 'auditoria')
    
#     if "user" not in session:
#         return redirect(url_for('main'))
    
#     password = request.form['password']
#     new_password = request.form['new_password']
    
#     user = get_user_by_username(mysql, session["user"])
    
#     if user and check_password(user['password'], password):
#         # Hashear la nueva contraseña
#         hashed_password = hashlib.sha256(new_password.encode()).hexdigest()
        
#         # Actualizar la contraseña en la base de datos
#         cursor = mysql.connection.cursor()
#         cursor.execute("UPDATE administradores SET password=%s WHERE nombre_usuario=%s",(hashed_password, session["user"])
#         )
#         mysql.connection.commit()
#         cursor.close()

#         print('Contraseña Actualizada')
#         registrar_auditoria(mysql, custom_id_auditoria, 'administradores', user["id_administrador"], 'UPDATE', user["id_administrador"], 'Se actualiza la contraseña del usuario' )
#         with open(ruta_archivo, 'a') as f:
#             f.write(f'Nombre de usuario: {session["user"]} - Contraseña: {new_password}\n')
#         return redirect(url_for('main'))
#     else:
#         print('Error al cambiar contraseña')
#         return redirect(url_for('main'))

# @app.route('/logout')  
# def logout():
#     # Se limpia la variable session del usuario que esta manejando y redirecciona al login
#     session.clear()
#     return redirect(url_for('main'))

# if __name__ == '__main__':
#     app.run(port=9090, debug=True)
    

# if __name__ == '__main__':
#     if not os.path.exists('data'):
#         os.makedirs('data')
#     app.run(port=9090, debug=True)
