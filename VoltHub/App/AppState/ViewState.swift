import Foundation

enum ViewState<Data> {
    case idle
    case loading
    case success(Data)
    case failure(Error)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var error: Error? {
        if case .failure(let err) = self { return err }
        return nil
    }

    var data: Data? {
        if case .success(let value) = self { return value }
        return nil
    }
}
