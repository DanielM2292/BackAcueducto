from flask import Flask, request, render_template, redirect, url_for, session
from config import Config
import hashlib, os
from flask_cors import CORS
from models import init_db, get_user_by_username, add_user, check_password, get_users, update_user

# Crear la conexion con la base de datos y llama a la inicializacion en el archivo models
app = Flask(__name__)
app.secret_key = "cualquier_clave"
app.config.from_object(Config)
mysql = init_db(app)

CORS(app, 
    origins=["http://localhost:5173"],
    supports_credentials=True,
    allow_headers=["Content-Type", "Authorization"])

def log_audit(mysql, action, table, id_registro, detalles, id_administrador):
    cursor = mysql.connection.cursor()
    id_auditoria = generate_custom_id('AUD', cursor, 'auditoria', 'id_auditoria')
    cursor.execute(
        'INSERT INTO auditoria (id_auditoria, tabla, id_registro_afectado, accion, id_administrador, detalles) VALUES (%s, %s, %s, %s, %s, %s)', 
        (id_auditoria, table, id_registro, action, id_administrador, detalles)
    )
    mysql.connection.commit()
    cursor.close()

@app.route('/')
def main():
    return render_template('login.html')

@app.route('/verify_role', methods=["POST"])
def verify_role():
    user = request.form.get("email")
    password = request.form.get("password")
    user_data = get_user_by_username(mysql, user)

    if user_data and check_password(user_data['password'], password):
        return jsonify({"rol": user_data['id_rol']}), 200 
    else:
        return jsonify({"message": "Usuario o contraseña incorrectos"}), 400

@app.route('/login', methods=["POST"])
def login():
    user = request.form.get("email")
    password = request.form.get("password")
    rol = request.form.get("rol")
    user_data = get_user_by_username(mysql, user)

    if user_data and check_password(user_data['password'], password):
        session['user'] = user
        session['password'] = password
        session['rol'] = user_data['id_rol']
        session['id_administrador'] = user_data['id_administrador']
        return redirect(url_for('index'))
    else:
        return jsonify({"message": "Usuario o contraseña incorrectos"}), 400

@app.route('/index')
def index():
    if not session.get("user"):
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
    session.clear()
    return redirect(url_for('main'))

# Rutas de Usuario
@app.route('/register', methods=["POST"])
def register():
    try:
        data = request.get_json()
        nombre = data.get("nombre")
        nombre_usuario = data.get("nombre_usuario")
        password = data.get("password")
        id_estado_empleado = data.get("id_estado_empleado")
        id_rol = data.get("id_rol")
        current_user = session.get("id_administrador")

        user = get_user_by_username(mysql, nombre_usuario)
        if user:
            return jsonify({"message": "Usuario ya existe"}), 400

        add_user(mysql, nombre, nombre_usuario, password, id_estado_empleado, id_rol, current_user)
        return jsonify({"message": "Usuario registrado exitosamente"}), 201
    except Exception as e:
        return jsonify({"message": f"Error al registrar usuario: {str(e)}"}), 500

@app.route('/listar_usuarios', methods=["GET"])
def listar_usuarios():
    try:
        users = get_users(mysql)
        for user in users:
            user['id_estado_empleado'] = (
                'Activo' if user['id_estado_empleado'] == 'ESTA001' else
                'Inactivo' if user['id_estado_empleado'] == 'ESTA002' else
                'Suspendido' if user['id_estado_empleado'] == 'ESTA003' else
                user['id_estado_empleado']
            )
            user['id_rol'] = (
                'Administrador' if user['id_rol'] == 'ROL001' else
                'Contador' if user['id_rol'] == 'ROL002' else
                'Secretario' if user['id_rol'] == 'ROL003' else
                user['id_rol']
            )
        return jsonify(users)
    except Exception as e:
        return jsonify({"message": f"Error al listar usuarios: {str(e)}"}), 500

@app.route('/actualizar_estado_usuario', methods=["PUT"])
def actualizar_estado_usuario():
    try:
        id_administrador = request.args.get("id_administrador")
        data = request.get_json()
        id_estado_empleado = data.get("id_estado_empleado")
        current_user = session.get("id_administrador")

        cursor = mysql.connection.cursor()
        cursor.execute('UPDATE administradores SET id_estado_empleado = %s WHERE id_administrador = %s', 
                    (id_estado_empleado, id_administrador))
        mysql.connection.commit()
        log_audit(mysql, 'UPDATE', 'administradores', id_administrador, f'Estado de usuario {id_administrador} actualizado', current_user)
        cursor.close()
        return jsonify({"message": "Estado del usuario actualizado exitosamente"}), 200
    except Exception as e:
        return jsonify({"message": f"Error al actualizar estado: {str(e)}"}), 500

# Rutas de Clientes
@app.route('/agregar_cliente', methods=["POST"])
def agregar_cliente_route():
    try:
        data = request.get_json()
        current_user = session.get("id_administrador")
        
        add_cliente(
            mysql,
            data.get("tipo_documento"),
            data.get("numero_documento"),
            data.get("nombre"),
            data.get("telefono"),
            data.get("direccion"),
            data.get("id_estado_cliente"),
            data.get("id_tarifa_estandar"),
            data.get("id_tarifa_medidor", "TARMED001"),
            current_user
        )
        return jsonify({"message": "Cliente agregado exitosamente"}), 201
    except Exception as e:
        return jsonify({"message": f"Error al agregar cliente: {str(e)}"}), 500

@app.route('/buscar_cliente', methods=["GET"])
def buscar_cliente():
    try:
        id_cliente = request.args.get("id_cliente")
        cliente = get_cliente_by_id(mysql, id_cliente)
        if cliente:
            return jsonify(cliente)
        return jsonify({"message": "Cliente no encontrado"}), 404
    except Exception as e:
        return jsonify({"message": f"Error al buscar cliente: {str(e)}"}), 500

@app.route('/actualizar_cliente', methods=["PUT"])
def actualizar_cliente_route():
    try:
        id_cliente = request.args.get("id_cliente")
        data = request.get_json()
        current_user = session.get("id_administrador")
        
        update_cliente(
            mysql,
            id_cliente,
            data.get("tipo_documento"),
            data.get("numero_documento"),
            data.get("nombre"),
            data.get("telefono"),
            data.get("direccion"),
            data.get("id_estado_cliente"),
            data.get("id_tarifa_estandar"),
            data.get("id_tarifa_medidor", "TARMED001"),
            current_user
        )
        return jsonify({"message": "Cliente actualizado exitosamente"}), 200
    except Exception as e:
        return jsonify({"message": f"Error al actualizar cliente: {str(e)}"}), 500

@app.route('/eliminar_cliente', methods=["DELETE"])
def eliminar_cliente_route():
    try:
        id_cliente = request.args.get("id_cliente")
        current_user = session.get("id_administrador")
        delete_cliente(mysql, id_cliente, current_user)
        return jsonify({"message": "Cliente eliminado exitosamente"}), 200
    except Exception as e:
        return jsonify({"message": f"Error al eliminar cliente: {str(e)}"}), 500

@app.route('/buscar_todos_clientes', methods=["GET"])
def buscar_todos_clientes():
    try:
        clientes = get_all_clientes(mysql)
        return jsonify(clientes)
    except Exception as e:
        return jsonify({"message": f"Error al obtener clientes: {str(e)}"}), 500

@app.route('/buscar_clientes_por_palabra', methods=["GET"])
def buscar_clientes_por_palabra():
    try:
        palabra_clave = request.args.get("palabra_clave")
        clientes = search_clientes_by_keyword(mysql, palabra_clave)
        return jsonify(clientes)
    except Exception as e:
        return jsonify({"message": f"Error al buscar clientes: {str(e)}"}), 500

# Rutas de Productos
@app.route('/agregar_producto', methods=["POST"])
def agregar_producto():
    try:
        data = request.get_json()
        descripcion_producto = data.get("descripcion_producto")
        cantidad = data.get("cantidad")
        valor_producto = data.get("valor_producto")
        current_user = session.get("id_administrador")
        
        add_product(mysql, descripcion_producto, cantidad, valor_producto, current_user)
        return jsonify({"message": "Producto agregado exitosamente"}), 201
    except Exception as e:
        return jsonify({"message": f"Error al agregar producto: {str(e)}"}), 500

@app.route('/buscar_producto', methods=["GET"])
def buscar_producto():
    try:
        id_producto = request.args.get("id_producto")
        product = get_product_by_id(mysql, id_producto)
        if product:
            return jsonify(product)
        return jsonify({"message": "Producto no encontrado"}), 404
    except Exception as e:
        return jsonify({"message": f"Error al buscar producto: {str(e)}"}), 500

@app.route('/actualizar_producto', methods=["PUT"])
def actualizar_producto():
    try:
        id_producto = request.args.get("id_producto")
        data = request.get_json()
        descripcion_producto = data.get("descripcion_producto")
        cantidad = data.get("cantidad")
        valor_producto = data.get("valor_producto")
        current_user = session.get("id_administrador")
        
        update_product_by_id(mysql, id_producto, descripcion_producto, cantidad, valor_producto, current_user)
        return jsonify({"message": "Producto actualizado exitosamente"}), 200
    except Exception as e:
        return jsonify({"message": f"Error al actualizar producto: {str(e)}"}), 500

@app.route('/eliminar_producto', methods=["DELETE"])
def eliminar_producto():
    try:
        id_producto = request.args.get("id_producto")
        current_user = session.get("id_administrador")
        delete_product_by_id(mysql, id_producto, current_user)
        return jsonify({"message": "Producto eliminado exitosamente"}), 200
    except Exception as e:
        return jsonify({"message": f"Error al eliminar producto: {str(e)}"}), 500

@app.route('/buscar_todos_productos', methods=["GET"])
def buscar_todos_productos():
    try:
        products = get_all_products(mysql)
        return jsonify(products)
    except Exception as e:
        return jsonify({"message": f"Error al obtener productos: {str(e)}"}), 500

@app.route('/buscar_productos_por_palabra', methods=["GET"])
def buscar_productos_por_palabra():
    try:
        palabra_clave = request.args.get("palabra_clave")
        products = search_products_by_keyword(mysql, palabra_clave)
        return jsonify(products)
    except Exception as e:
        return jsonify({"message": f"Error al buscar productos: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(port=9090, debug=True)