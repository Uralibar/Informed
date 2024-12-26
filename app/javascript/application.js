// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"


document.addEventListener('turbo:load', () => {
    // Get the modal
    const modal = document.getElementById('myModal');
  
    // Get the buttons that open the modal
    const btnFollowers = document.getElementById('myBtnFollowers');
    const btnFollowees = document.getElementById('myBtnFollowees');
  
    // Check if the buttons exist before adding event listeners (in case the page is dynamically loaded)
    if (btnFollowers) {
      btnFollowers.onclick = function () {
        modal.style.display = 'block';
      };
    }
  
    if (btnFollowees) {
      btnFollowees.onclick = function () {
        modal.style.display = 'block';
      };
    }
  
    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
      if (event.target === modal) {
        modal.style.display = 'none';
      }
    };
  });
  