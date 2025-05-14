import { ref } from 'vue'

// Hàm composable quản lý phân trang, nhận vào hàm fetchFunction để lấy dữ liệu và trang bắt đầu (mặc định là 1)
export default function usePaging(fetchFunction, initialPage = 1) {

  const currentPage = ref(initialPage)

  const totalPages = ref(1)

  const totalCount = ref(0)

  // Hàm xử lý khi chuyển trang, chỉ cho phép chuyển nếu trang hợp lệ
  const handlePageChange = (page) => {
    if (page < 1 || page > totalPages.value) return
    currentPage.value = page
    fetchFunction()
  }

  // Hàm cập nhật thông tin phân trang từ dữ liệu trả về của API
  const updatePagination = (paginationData) => {
    currentPage.value = paginationData.current_page
    totalPages.value = paginationData.total_pages
    totalCount.value = paginationData.total_count
  }

  // Trả về các biến và hàm để sử dụng trong component
  return {
    currentPage,
    totalPages,
    totalCount,
    handlePageChange,
    updatePagination
  }
}