document.addEventListener('turbo:load', function() {
  // console.log("ok")
  let account = document.querySelector('#account');

  // console.log(account)
  account.addEventListener('click', function(event) {
    event.preventDefault();
    let menu = document.querySelector('#dropdown-menu');
    // console.log(menu)
    menu.classList.toggle('active');
  });
});
