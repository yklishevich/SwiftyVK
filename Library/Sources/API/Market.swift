public extension Api {
    public enum Market: String, Method {
        case get = "market.get"
        case getById = "market.getById"
        case search = "market.search"
        case getAlbums = "market.getAlbums"
        case getAlbumById = "market.getAlbumById"
        case createComment = "market.createComment"
        case getComments = "market.getComments"
        case deleteComment = "market.deleteComment"
        case restoreComment = "market.restoreComment"
        case editComment = "market.editComment"
        case reportComment = "market.reportComment"
        case getCategories = "market.getCategories"
        case report = "market.report"
        case add = "market.add"
        case edit = "market.edit"
        case delete = "market.delete"
        case restore = "market.restore"
        case reorderItems = "market.reorderItems"
        case reorderAlbums = "market.reorderAlbums"
        case addAlbum = "market.addAlbum"
        case editAlbum = "market.editAlbum"
        case deleteAlbum = "market.deleteAlbum"
        case removeFromAlbum = "market.removeFromAlbum"
        case addToAlbum = "market.addToAlbum"
    }
}
