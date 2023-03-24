import 'dart:ffi';

typedef RemoteHookingCreateAndInject = int Function(
    String targetProcess, String dllLibrary, int threadId, int data, Pointer<Int32> pOutThreadId);

class EasyHook {
  // static final DynamicLibrary _dll = DynamicLibrary.open('assets/library/easyhookdll');

  // static final RemoteHookingCreateAndInject remoteHookingCreateAndInject =
  //     _dll.lookupFunction<NativeFunction<RemoteHookingCreateAndInject>, RemoteHookingCreateAndInject>(
  //         'RemoteHookingCreateAndInject');
}
