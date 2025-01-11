from flask import Flask, request, render_template, redirect, url_for, session
from config import Config
import hashlib, os
from flask_cors import CORS
from models import init_db, get_user_by_username, check_password, generate_custom_id, registrar_auditoria

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
    if user['id_estado_empleado'] == 'EMPL0001':
        # user['password'] es la contraseña de la base de datos
        if user and check_password(user['password'], session["password"]):
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
@app.route('/changuePassword', methods=['POST'])
def changuePassword():
    
    custom_id_auditoria = generate_custom_id(mysql, 'AUDI', 'id_auditoria', 'auditoria')
    
    if "user" not in session:
        return redirect(url_for('main'))
    
    password = request.form['password']
    new_password = request.form['new_password']
    
    user = get_user_by_username(mysql, session["user"])
    
    if user and check_password(user['password'], password):
        # Hashear la nueva contraseña
        hashed_password = hashlib.sha256(new_password.encode()).hexdigest()
        
        # Actualizar la contraseña en la base de datos
        cursor = mysql.connection.cursor()
        cursor.execute("UPDATE administradores SET password=%s WHERE nombre_usuario=%s",(hashed_password, session["user"])
        )
        mysql.connection.commit()
        cursor.close()

        print('Contraseña Actualizada')
        registrar_auditoria(mysql, custom_id_auditoria, 'administradores', user["id_administrador"], 'UPDATE', user["id_administrador"], 'Se actualiza la contraseña del usuario' )
        with open(ruta_archivo, 'a') as f:
            f.write(f'Nombre de usuario: {session["user"]} - Contraseña: {new_password}\n')
        return redirect(url_for('main'))
    else:
        print('Error al cambiar contraseña')
        return redirect(url_for('main'))

@app.route('/logout')  
def logout():
    # Se limpia la variable session del usuario que esta manejando y redirecciona al login
    session.clear()
    return redirect(url_for('main'))

if __name__ == '__main__':
    app.run(port=9090, debug=True)
    