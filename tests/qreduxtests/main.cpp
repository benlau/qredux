#include <QString>
#include <QtTest>
#include <TestRunner>

#if defined(Q_OS_MAC) || defined(Q_OS_LINUX)
#include <execinfo.h>
#include <signal.h>
#include <unistd.h>
void handleBacktrace(int sig) {
    void *array[100];
    size_t size;

    // get void*'s for all entries on the stack
    size = backtrace(array, 100);

    // print out all the frames to stderr
    fprintf(stderr, "Error: signal %d:\n", sig);
    backtrace_symbols_fd(array, size, STDERR_FILENO);
    exit(1);
}
#endif

int main(int argc, char *argv[])
{
#if defined(Q_OS_MAC) || defined(Q_OS_LINUX)
    signal(SIGSEGV, handleBacktrace);
#endif
    QGuiApplication app(argc, argv);

    TestRunner runner;
    runner.addImportPath("qrc:///");
    runner.add(QString(QUICK_TEST_SOURCE_DIR));

    bool error = runner.exec(app.arguments());

    if (!error) {
        qDebug() << "All test cases passed!";
    }

    return error;
}
