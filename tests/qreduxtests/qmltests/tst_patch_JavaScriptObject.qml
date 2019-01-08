import QtQuick 2.0
import QtTest 1.0
import QRedux 1.0

Item {

    TestCase {
        name: "patch_JavaScriptObject"

        QtObject {
            id: provider

            property var v1: ({})
        }


        function test_patch_nestedJavaScriptObject() {
            var object1 = {
                v1: {
                    v2: "2"
                }
            }

            var object2 = {
                v1: {
                    v3: "3"
                }
            }

            var changes;

            changes = QRedux.diff({}, object1);

            QRedux.patch(provider, changes);

            compare(provider.v1.v2, "2");

            changes = QRedux.diff(object1, object2);

            QRedux.patch(provider, changes);

            compare(provider.v1.v2, "2");
            compare(provider.v1.v3, "3");
        }

    }
}
