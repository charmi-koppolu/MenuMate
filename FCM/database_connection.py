import pymysql

class SQLClient:
    def __init__(self, host, user, password, database, port=3306):
        self.connection = pymysql.connect(
            host=host,
            user=user,
            password=password,
            database=database,
            port=port,
            cursorclass=pymysql.cursors.DictCursor  # rows as dicts
        )

    def execute(self, query, params=None):
        with self.connection.cursor() as cursor:
            cursor.execute(query, params or [])
            if cursor.description:  # means rows returned
                return cursor.fetchall()
            return None

    def commit(self):
        self.connection.commit()

    def close(self):
        self.connection.close()

# client = SQLClient("localhost", "root", "password", "dining_information")
#
# rows = client.execute("SELECT * FROM dining_users;")
# print(rows)
#
# client.close()