from hana_ml import dataframe
from hana_ml.dataframe import ConnectionContext
from sklearn import linear_model
import pickle
from flask import Flask
from flask import request
from flask_restful import reqparse, abort, Api, Resource
from flask_cors import CORS
import os
if not os.path.exists('model.pkl'):
    host = ".......hanacloud.ondemand.com"
    port = 443
    user = 'DBADMIN'
    password = ''
    cc = ConnectionContext(host, port, user, password)
    with cc:
        df = (cc.table(table= 'HouseData', schema='HOUSE' ).select('*'))
        pandas_df = df.collect()
        reg = linear_model.LinearRegression()
        reg.fit(pandas_df.drop(['price','hotwaterheating','airconditioning','prefarea','mainroad','semi-furnished','unfurnished'],axis='columns'),pandas_df.price)
        pickle.dump(reg,open('model.pkl','wb'))
app = Flask(__name__)
CORS(app, support_credentials=True)

api = Api(app)
model = pickle.load(
    open('model.pkl', 'rb'))
# argument parsing
parser = reqparse.RequestParser()
class getHousePrice(Resource):
    def get(self):
        try:
            area = float(request.args.get('Area'))
            bedrooms = int(request.args.get('Bedrooms'))
            bathrooms = int(request.args.get('Bathrooms'))
            stories = int(request.args.get('Stories'))
            guest = int(request.args.get('Guest'))
            basement = int(request.args.get('Basement'))
            parking = int(request.args.get('Parking'))
            areperbedroom = float(request.args.get('AreaPerBedRoom'))
            bbratio = float(request.args.get('BBRatio'))

            payload = {"area" : area,
                        "bedrooms" : bedrooms,
                        "bathrooms" :bathrooms,
                        "stories" :stories,
                        "guest" : guest,
                        "basement" : basement,
                        "parking" : parking,
                        "areperbedroom" : areperbedroom,
                        "bbratio" : bbratio}

            prediction = model.predict(
            [[area, bedrooms, bathrooms, stories, guest, basement, parking, areperbedroom, bbratio]])
            output = round(prediction[0], 2)
            payload1 = {"House Price" : output}
        except:
            payload1 = {"House Price" : 0.0}
        return payload1

api.add_resource(getHousePrice, '/')

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 3000))
    app.run(host='0.0.0.0', port=port,debug=True,use_reloader=False)
