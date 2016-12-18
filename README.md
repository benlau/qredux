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

**QRedux.createStore(reducer, [preloadedState], [enhancer])**

It is equivalent to Redux.createStore()

[API Reference ‧ Redux](http://redux.js.org/docs/api/)

**QRedux.combineReducers(reducers)**

It is equivalent to Redux.combineReducers()

[API Reference ‧ Redux](http://redux.js.org/docs/api/)

**QRedux.applyMiddleware(...middlewares)**

It is equivalent to Redux.applyMiddleware()

[API Reference ‧ Redux](http://redux.js.org/docs/api/)

**QRedux.bindActionCreators(actionCreators, dispatch)**

It is equivalent to Redux.bindActionCreators()

[API Reference ‧ Redux](http://redux.js.org/docs/api/)

**QRedux.compose(...functions)**

It is equivalent to Redux.compose()

[API Reference ‧ Redux](http://redux.js.org/docs/api/)



**QRedux.diff(prevState, currentState)**


