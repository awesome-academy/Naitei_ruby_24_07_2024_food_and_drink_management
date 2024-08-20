document.addEventListener('DOMContentLoaded', () => {
  // Lấy giá trị của `params[:search][:query]` từ URL
  const urlParams = new URLSearchParams(window.location.search);
  const query = urlParams.get('search[query]');

  // Nếu có giá trị `query`, lưu vào localStorage
  if (query) {
    localStorage.setItem('searchQuery', query);
  }

  // Lấy giá trị từ localStorage và gán vào trường tìm kiếm
  const searchInput = document.querySelector('input[name="search[query]"]');
  console.log(searchInput);
  if (searchInput) {
    searchInput.value = localStorage.getItem('searchQuery') || '';
    console.log(searchInput.value);
  }

  // Lưu lại giá trị tìm kiếm vào localStorage khi form được submit
  const searchForm = document.querySelector('form[action*="/products"]');
  if (searchForm) {
    searchForm.addEventListener('submit', () => {
      const queryValue = searchInput ? searchInput.value : '';
      localStorage.setItem('searchQuery', queryValue);
    });
  }
});
