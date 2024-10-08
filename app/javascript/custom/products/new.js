document.addEventListener('turbo:load', function() {
  const createButton = document.getElementById('product-new');
  const closeButton = document.getElementById('close-new-product-modal');
  const modalProduct = document.getElementById('product-modal');

  createButton.addEventListener('click', function() {
    modalProduct.classList.remove('hidden');
  });

  closeButton.addEventListener('click', function() {
    modalProduct.classList.add('hidden');
    window.location.reload();
  });
});
