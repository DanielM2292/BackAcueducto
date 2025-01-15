from app import create_app

app = create_app()
    
if __name__ == '__main__':
    app.run(port=9090, debug=True)
    
    
# if not os.path.exists('data'):
#         os.makedirs('data')