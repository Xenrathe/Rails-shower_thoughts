function actionButton(button)
{
  // e.preventDefault();

  const childImg = button.querySelector("img:first-child");
  const thoughtId = button.getAttribute('data-thought-id');
  let url = `/thoughts/${thoughtId}/favorite`;

  if (button.classList.contains('hide'))
    url = `/thoughts/${thoughtId}/hide`;
  else if (button.classList.contains('spotlight'))
    url = `/thoughts/${thoughtId}/spotlight`;
  else if (button.classList.contains('shadow'))
    url = `/thoughts/${thoughtId}/shadow`;

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
      if (data.status === 'unshadowed' || data.status === 'unfavorited' || data.status === 'unhidden' || data.status === 'unspotlighted') {
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
}

function applySelectedFilter(selected_filter) {
  const filterButtons = document.querySelectorAll(('.filter'))
  filterButtons.forEach(function (filter) {
    if (filter.getAttribute('data-filter') === selected_filter){
      filter.classList.add('selected');
    }
    else{
      filter.classList.remove('selected');
    }
  });
}

function initializeFunctions()
{
  const actionButtons = document.querySelectorAll('.favorite, .hide, .spotlight, .shadow');

  actionButtons.forEach(function (button) {
    button.addEventListener('click', function (e) {
      e.preventDefault();
      actionButton(button);
    });
  });

  const storageKey = 'selected_filter';
  const cookies = document.cookie.split(';');
  for (let i = 0; i < cookies.length; i++) {
    const cookie = cookies[i].trim();
    if (cookie.startsWith(storageKey + '=')) {
      applySelectedFilter(decodeURIComponent(cookie.substring(storageKey.length + 1)));
    }
  }
}

initializeFunctions();
document.addEventListener('turbo:render', function() { initializeFunctions(); });