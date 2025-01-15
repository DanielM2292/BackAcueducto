# from flask import Flask, request, render_template, redirect, url_for, session, jsonify
# from config import Config
# from datetime import datetime
# import hashlib, os
# from flask_cors import CORS
# from models import init_db, get_user_by_username, generate_custom_id, registrar_auditoria, get_clientes, generar_facturas

# # Crear la conexion con la base de datos y llama a la inicializacion en el archivo models
# app = Flask(__name__)
# app.config.from_object(Config)
# mysql = init_db(app)
# CORS(app)

# @app.route('/generarFacturas', methods=['POST'])
# def facturas():
    
#     fecha_actual = datetime.now()
#     mes_siguiente = fecha_actual.month + 1
#     anio = fecha_actual.year
    
#     if mes_siguiente > 12:
#         mes_siguiente = 1
#         anio += 1
        
#     fecha_vencimiento = fecha_actual.replace(year=anio, month=mes_siguiente)
    
#     clientes = get_clientes(mysql)
#     if clientes:
#         for cliente in clientes:  # Iterar sobre cada cliente
#             id_cliente = cliente['id_cliente']
#             custom_id = generate_custom_id(mysql, 'FACT', 'id_factura', 'facturas')
#             custom_id_auditoria = generate_custom_id(mysql, 'AUDI', 'id_auditoria', 'auditoria')
#             generar_facturas(mysql, custom_id, fecha_vencimiento, id_cliente, 'ESTFAC0001')
#             registrar_auditoria(mysql, custom_id_auditoria, 'facturas', custom_id, 'INSERT', 'ADMI0003', f'Factura generada para el cliente {cliente['nombre']}' )
            
#         return jsonify({'message': 'Facturas generadas'}), 200
#     else:
#         return jsonify({'message': 'No existen clientes'}), 404
    
    
# if __name__ == '__main__':
#     app.run(port=9090, debug=True)