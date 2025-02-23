import { ref } from 'vue'

export default function usePaging(fetchFunction, initialPage = 1) {
  const currentPage = ref(initialPage)
  const totalPages = ref(1)
  const totalCount = ref(0)

  const handlePageChange = (page) => {
    if (page < 1 || page > totalPages.value) return
    currentPage.value = page
    fetchFunction()
  }

  const updatePagination = (paginationData) => {
    currentPage.value = paginationData.current_page
    totalPages.value = paginationData.total_pages
    totalCount.value = paginationData.total_count
  }

  return {
    currentPage,
    totalPages,
    totalCount,
    handlePageChange,
    updatePagination
  }
}
