import QtQuick 2.0
import QtTest 1.0
import QRedux 1.0

Item {

    TestCase {
        name: "Redux"

        function test_store_create() {
            var store = QRedux.createStore(function(state, action) {
                if (state === undefined) {
                    return { actions: [ action.type] };
                }
                state.actions.push(action.type);
                return state;
            });
            var state = store.getState();
            compare(state.hasOwnProperty("actions"), true);
            compare(state.actions.length, 1)
            store.dispatch({type: "dummy"});
            compare(state.actions.length, 2);
            compare(state.actions[1], "dummy");
        }

        function test_diff() {
            var obj = {}
            compare(QRedux.diff(obj, obj), undefined);
            compare(QRedux.diff({}, {}), {});
            compare(QRedux.diff({v1: 1},{v1:1, v2:2}), {v2:2});

            var d1 = {
                o1: {
                    v1: 1
                }
            };
            var d2 = {
                o1: {
                    v1: 1,
                    v2: 2
                }
            }
            var res = {
                o1: {
                    v2: 2
                }
            }

            compare(QRedux.diff(d1,d2), res);

            compare(QRedux.diff([],[]), []);
            compare(QRedux.diff([3,4],[1,2]), [1,2]);
        }

        function test_ImmutabilityHelper() {
            var state1 = ["x"];
            var state2 = QRedux.update(state1, {$push: ["y"]}); // ['x', 'y']
            compare(state2, ["x", "y"])
        }

        function test_Middleware() {
            var reducer = function(state, action) {
                if (state === undefined) {
                    return {value: 0}
                }
                if (action.hasOwnProperty("value")) {
                    return {
                        value: action.value + state.value
                    }
                }
                return state;
            }
            var middleware = function(store) {
                return function(next) {
                    return function(action) {
                        if (action.hasOwnProperty("value")) {
                            action.value++;
                        }
                        next(action);
                    }
                }
            }

            var store = Redux.createStore(reducer, Redux.applyMiddleware(middleware));

            compare(store.getState().value, 0);
            store.dispatch({type:"dummy", value:1});
            compare(store.getState().value, 2);

        }

        Item {
            id: signalProxy

            signal signal1
            property int signal1Count: 0

            signal signal2(int v1, string v2)
            property int signal2Count: 0

            onSignal1: {
                signal1Count++;
            }

            onSignal2: {
                signal2Count++;
            }
        }

        function test_SignalProxyMiddleware() {
            var reducer = function() {};
            var store = Redux.createStore(reducer,
                                          Redux.applyMiddleware(QRedux.signalProxyMiddleware(signalProxy)));

            store.dispatch({type: "signal1"});
            compare(signalProxy.signal1Count, 1);

            try { // Uncaught exception: Insufficient arguments
                store.dispatch({type: "signal2"});
            } catch (e) {
            }

            compare(signalProxy.signal2Count, 0);

            store.dispatch({type: "signal2", arguments: [1,"2"] });
            compare(signalProxy.signal2Count, 1);
        }

        Item {
            id: mockProvider
            property int value1: 0
            property real value2: 0.0
            property string value3: ""

            property alias value4 : subItem

            Item {
                id: subItem
                property int value1
            }

            /// Array
            property var value5

            /// Test object
            property var value6: ({})
        }

        QtObject {
            id: qtObject
        }

        function test_patch() {
            mockProvider.value1 = 0;

            compare(QRedux._isQtObject({}), false);

            compare(QRedux._isQtObject(mockProvider), true);

            compare(QRedux._isQtObject(mockProvider.value0), false);
            compare(QRedux._isQtObject(mockProvider.value4), true);
            compare(QRedux._isQtObject(mockProvider.value6), false);
            compare(QRedux._isQtObject(qtObject), true);

            QRedux.patch(mockProvider, undefined);
            compare(mockProvider.value1, 0);

            QRedux.patch(mockProvider, {});
            compare(mockProvider.value1, 0);

            QRedux.patch(mockProvider, {
                               value0: 123,
                               value1: 1,
                               value2: 2.0,
                               value3: "3",
                               value4: {
                                   value1: 5
                               },
                               value5: ["abc", "def"],
                               value6: {
                                    value1: 6,
                                    value2: 6.2
                               }
                           });
            compare(mockProvider.value1, 1);
            compare(mockProvider.value2, 2.0);
            compare(mockProvider.value3, "3");
            compare(mockProvider.value4.value1, 5);
            compare(mockProvider.value5, ["abc", "def"]);

            compare(mockProvider.value6, {value1: 6, value2: 6.2});
        }

        function test_patch_array() {
            var diff = {
                value: [5,6]
            }

            var target = {
                value: [0,1,2,3]
            }

            QRedux.patch(target, diff);

            compare(target.value, [5,6]);
        }

        function test_SyncMiddleware() {
            var reducer = function(state, action) {
                if (state === undefined) {
                    return{
                        value1 :0
                    }
                }

                if (action.type === "inc") {
                    state = {value1: state.value1 + 1};
                }

                return state;
            };

            mockProvider.value1 = 0;

            var store = QRedux.createStore(reducer,
                                          QRedux.applyMiddleware(QRedux.syncMiddleware(mockProvider)));

            store.dispatch({type: "inc"});
            compare(store.getState().value1, 1);
            compare(mockProvider.value1, 1);

            store.dispatch({type: "inc"});
            compare(store.getState().value1, 2);
            compare(mockProvider.value1, 2);
        }

        function test_mapReducer() {
            var reducer1Count = 0;
            var reducer2Count = 0;

            function reducer1(state, action) {
                reducer1Count++;
                return state;
            }

            function reducer2(state, action) {
                reducer2Count++;
                return state;
            }

            var table = {
                "reducer1" : reducer1,
                "reducer2" : reducer2
            }

            var reducer = QRedux.mapReducers(table);

            var store = QRedux.createStore(reducer);

            compare(reducer1Count, 0);
            compare(reducer2Count, 0);

            store.dispatch({type: "reducer1"});
            compare(reducer1Count, 1);
            compare(reducer2Count, 0);

            store.dispatch({type: "reducer2"});
            compare(reducer1Count, 1);
            compare(reducer2Count, 1);
        }

        function test_chainReducer() {
            var reducer1Count = 0;
            var reducer2Count = 0;

            function reducer1(state, action) {
                if (state === undefined) {
                    state = {};
                }

                reducer1Count++;
                return state;
            }

            function reducer2(state, action) {
                reducer2Count++;
                return state;
            }

            var reducer = QRedux.chainReducers([reducer1, reducer2]);

            var store = QRedux.createStore(reducer);

            compare(reducer1Count, 1);
            compare(reducer2Count, 1);

            compare(store.getState(), {});
            store.dispatch({type: "reducer1"});

            compare(reducer1Count, 2);
            compare(reducer2Count, 2);
        }

        function test_merge() {
            var input1 = {
                value1: 1,
                value2: {
                    value3: 3.0,
                    value4: [ {a: 1}, {b:2}]
                }
            }
            var output = QRedux.merge({}, input1);

            compare(JSON.stringify(input1), JSON.stringify(output));
            compare(output.value2 !== input1.value2, true);
            compare(output.value2.value4 !== input1.value2.value4, true);
        }

    }
}
