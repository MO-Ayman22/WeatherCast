//
//  UndoLastDeleteUseCase.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 14/06/2026.
//

import Foundation
import Combine

class UndoLastDeleteUseCase {

    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<Void, Error> {
        repository.undoLastDelete()
    }
}
