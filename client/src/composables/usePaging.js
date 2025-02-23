import { ref } from 'vue'

export default function usePaging(fetchFunction, initialPage = 1, initialPerPage = 10) {
  const currentPage = ref(initialPage)
  const totalPages = ref(1)
  const perPage = ref(initialPerPage)
  const totalCount = ref(0)

  const handlePageChange = (page) => {
    if (page < 1 || page > totalPages.value) return
    currentPage.value = page
    fetchFunction()
  }

  const handlePerPageChange = (newPerPage) => {
    perPage.value = newPerPage
    currentPage.value = 1
    fetchFunction()
  }

  const updatePagination = (paginationData) => {
    currentPage.value = paginationData.current_page
    totalPages.value = paginationData.total_pages
    totalCount.value = paginationData.total_count
    perPage.value = paginationData.per_page
  }

  return {
    currentPage,
    totalPages,
    perPage,
    totalCount,
    handlePageChange,
    handlePerPageChange,
    updatePagination
  }
}
