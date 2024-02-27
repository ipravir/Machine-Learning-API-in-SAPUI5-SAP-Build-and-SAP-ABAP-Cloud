sap.ui.define([
    "sap/ui/core/mvc/Controller"
],
    /**
     * @param {typeof sap.ui.core.mvc.Controller} Controller
     */
    function (Controller) {
        "use strict";

        return Controller.extend("fioritest.controller.main", {
            onInit: function () {

            },

            onClick: function (oEvent) {
                let Area = this.getView().byId("inArea").getValue();
                let BedRooms = this.getView().byId("inBeds").getValue();
                let Bathrooms = this.getView().byId("inBaths").getValue();
                let Stories = this.getView().byId("inStore").getValue();
                let Guest = this.getView().byId("inGuest").getValue();
                let Basement = this.getView().byId("inBase").getValue();
                let Parking = this.getView().byId("inPark").getValue();
                let AreaPerBedRoom = this.getView().byId("inAreaBed").getValue();
                let BBRatio = this.getView().byId("inBBRatio").getValue();

                let baseUrl = "https://......hana.ondemand.com/?"
                let sUrl = baseUrl + "Area=" + Area + "&Bedrooms=" + BedRooms + "&Bathrooms=" + Bathrooms + "&Stories=" + Stories +
                    "&Guest=" + Guest + "&Basement=" + Basement + "&Parking=" + Parking + "&AreaPerBedRoom=" + AreaPerBedRoom + "&BBRatio=" + BBRatio
                var that = this;
                var settings = {
                    "url": sUrl,
                    "method": "GET",
                    "timeout": 0,
                };
                $.ajax(settings).done(function (response) {
                    sap.ui.getCore().byId("application-fioritest-display-component---main--lblMsg").setText(sap.ui.getCore().byId("application-fioritest-display-component---main--lblMsg").getText() + "   " + response['House Price']);
                });
            }
        });
    });
