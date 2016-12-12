.pragma library
Qt.include("./signalproxymiddleware.js");
Qt.include("./syncmiddleware.js");

/* redux.min.js (3.6.0) */
Qt.include("./redux.min.js");
var createStore = Redux.createStore;
var combineReducers = Redux.combineReducers;
var bindActionCreators = Redux.bindActionCreators;
var applyMiddleware = Redux.applyMiddleware;
var compose = Redux.compose;

/* Immutability helper (2.0.0) */
Qt.include("./immutabilityhelper.min.js");
var update = ImmutabilityHelper.newContext();

/* Custom API */
Qt.include("./custom.js");
