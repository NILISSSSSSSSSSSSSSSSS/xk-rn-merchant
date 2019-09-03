export default class Pagination {
    constructor() {
        this.loading = false;
        this.page = 1;
        this.limit = 10;
        this.refreshing = false;
        this.hasMore = false;
        this.isFirstLoad = false;
    }
    StartFetch(page = 1, limit = 10, isFirstLoad = false) {
        this.loading = true;
        this.refreshing = page === 1;
        this.hasMore = false;
        this.isFirstLoad = isFirstLoad;
        this.limit = limit;
        this.page = page;
        return this;
    }
    EndFetch(total) {
        this.loading = false;
        this.refreshing = false;
        this.hasMore = (total > this.page*this.limit);
        this.isFirstLoad = false;
        return this;
    }
    ErrorFetch() {
        this.loading = false;
        this.refreshing = false;
        this.hasMore = false;
        this.isFirstLoad = false;
        return this;
    }
}