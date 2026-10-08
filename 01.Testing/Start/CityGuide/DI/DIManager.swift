//
//  DIManager.swift
//  CityGuide
//
//  Created by David Prochazka on 18.03.2025.
//
import Foundation

final class DIContainer {
    typealias Resolver = () -> Any

    private var resolvers = [String: Resolver]()
    private var cache = [String: Any]()

    static let shared = DIContainer()

    init() {
        registerDependencies()
    }

    func register<T, R>(_ type: T.Type, cached: Bool = false, service: @escaping () -> R) {
        let key = String(reflecting: type)
        resolvers[key] = service

        if cached {
            cache[key] = service()
        }
    }

    func resolve<T>() -> T {
        let key = String(reflecting: T.self)

        if let cachedService = cache[key] as? T {
            print("🥣 Resolving cached instance of \(T.self).")

            return cachedService
        }

        if let resolver = resolvers[key], let service = resolver() as? T {
            print("🥣 Resolving new instance of \(T.self).")

            return service
        }

        fatalError("🥣 \(key) has not been registered.")
    }
}

extension DIContainer {
    func registerDependencies() {
#if os(watchOS)
        // the watch app needs only the storage: it keeps the places it received
        register(DataManaging.self, cached: true) {
            CoreDataManager()
        }
#else
        register(APIManaging.self, cached: true) {
            APIManager()
        }
        
        register(DataManaging.self, cached: true) {
            MockDataManager()
        }
        
        register(LocationManaging.self, cached: true) {
            CoreLocationManager()
        }
#endif
    }
}

