from flask import Flask, jsonify, request, render_template, redirect, url_for, session
from config import Config
from flask_cors import CORS
from models import init_db, get_user_by_username, add_user, check_password, get_users, update_user

# Crear la conexion con la base de datos y llama a la inicializacion en el archivo models
app = Flask(__name__)
# Esta clave la requiere session para que el pueda encriptar el inicio de sesion
app.secret_key = "cualquier_clave"
app.config.from_object(Config)
mysql = init_db(app)
CORS(app)

@app.route('/')
def main():
    return render_template('login.html')

@app.route('/login', methods=["POST"])
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

@app.route('/index')
def index():
    if not session["user"] or not session["password"] or not session["rol"]:
        return redirect(url_for('main'))

    user = get_user_by_username(mysql, session["user"])
    # user['password'] es la contraseña de la base de datos
    if user and check_password(user['password'], session["password"]):
        if user['id_rol'] == '1' and session["rol"] == "administrador":
            return render_template('admin.html') 
        elif user['id_rol'] == '2' and session["rol"] == "auxiliar" :
            return render_template('auxiliar.html')
        elif user['id_rol'] == '3' and session["rol"] == "contador":
            return render_template('contador.html')
    return redirect(url_for('main'))
    
@app.route('/logout')  
def logout():
    # Se limpia la variable session del usuario que esta manejando y redirecciona al login
    session.clear()
    return redirect(url_for('main'))

if __name__ == '__main__':
    app.run(port=9090, debug=True)
    