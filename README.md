Redux for QML
=============

QRedux bundle qmlified Redux and Immutability-Helper plus few utilities into a single package for using Redux in QML.  

It is still under development. Use it at your own risk.

Reference
---------

1. [My first attempt to use Redux in a QML application – Medium](https://medium.com/@benlaud/my-first-attempt-to-use-redux-in-a-qml-application-dc7a21689fb#.w3i809t7m)

API
===

```
import QRedux 1.0
```

**createStore(reducer, [preloadedState], [enhancer])**

It is equivalent to Redux.createStore()

[API Reference ‧ Redux](http://redux.js.org/docs/api/)

**combineReducers(reducers)**

**applyMiddleware(...middlewares)**

**bindActionCreators(actionCreators, dispatch)**

**compose(...functions)**

**diff(prevState, currentState)**


