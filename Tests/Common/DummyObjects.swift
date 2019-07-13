/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

struct DummyPerson: Codable, Equatable {
    let name: String
    let age: Int
    let parents: [DummyPerson]
    let relations: [DummyPerson]
}
