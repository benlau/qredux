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

**QRedux.update()**

Mutate a copy of data without changing the original source.
It is equivalent to ImmutabilityHelper.update().

[Immutability Helpers - React](https://facebook.github.io/react/docs/update.html)

**QRedux.diff(prevState, currentState)**

Compare the different between prevState and currentState. Return undefined if they are the same.

**QRedux.patch(dest, changes)**

Apply the changes to dest object. It will copy attributes from changes to dest only if such attribute is also existed on dest object.

**QRedux.mapReducers(mappingTable)**

The mapReducers helper function turns multiple reducers into a single reducing function according to the mapping table.

```

function addTask(state, action) {
   ...
}

function removeTask(state, aciton) {
   ...
}

var table = {
  "addTask" : addTask,
  "removeTask": removeTask
}

var reducer = QRedux.mapReducers(table);

```

The resulting reducer read from the input action type, and find a corresponding reducer according to the mapping table. Only one of the reducer will be invoked.

**QRedux.chainReducers(reducers)**

**QRedux.signalProxyMiddleware(proxy)**

**QRedux.syncMiddleware(provider)**
