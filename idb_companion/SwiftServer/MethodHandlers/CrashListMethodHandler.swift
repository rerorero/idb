/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import IDBGRPCSwift
import GRPC

struct CrashListMethodHandler {

  let commandExecutor: FBIDBCommandExecutor

  func handle(request: Idb_CrashLogQuery, context: GRPCAsyncServerCallContext) async throws -> Idb_CrashLogResponse {
    let predicate = CrashLogQueryValueTransformer.predicate(from: request)
    let crashes: [FBCrashLogInfo] = try await BridgeFuture.value(commandExecutor.crash_list(predicate))
    return Idb_CrashLogResponse.with {
      $0.list = crashes.map(CrashLogInfoValueTransformer.responseCrashLogInfo(from:))
    }
  }

}
