document.addEventListener('DOMContentLoaded', function () {
  const actionButtons = document.querySelectorAll('.favorite, .hide');

  actionButtons.forEach(function (button) {
    button.addEventListener('click', function (e) {
      e.preventDefault();

      const childImg = button.querySelector("img:first-child");
      const thoughtId = this.getAttribute('data-thought-id');
      let url = `/thoughts/${thoughtId}/favorite`;

      if (button.classList.contains('hide'))
        url = `/thoughts/${thoughtId}/hide`;

      fetch(url, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          'Content-Type': 'application/json',
        },
        credentials: 'same-origin',
      })
        .then(response => response.json())
        .then(data => {
          if (data.status === 'unfavorited' || data.status === 'unhidden') {
            // Toggle classes
            childImg.classList.add('img-off');
            childImg.classList.remove('img-on');
          }
          else {
            // Toggle classes
            childImg.classList.add('img-on');
            childImg.classList.remove('img-off');
          }
          // Handle other responses or error cases if needed
        })
        .catch(error => {
          console.error('Error:', error);
        });
    });
  });
});