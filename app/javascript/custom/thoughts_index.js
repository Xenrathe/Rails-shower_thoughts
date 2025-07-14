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
        if (data.status === 'spotlighted') {
          location.reload();
        }
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

function loadMoreThoughts() {
  const thoughtsContainer = document.querySelector('.thoughts');
  var currentPage = parseInt(document.querySelector("#current-page").value);

  const url = `/thoughts?page=${currentPage + 1}`;
  fetch(url)
    .then((response) => response.text())
    .then((data) => {
      if (data != "Empty")
      {
        currentPage += 1;
        data = "<div class=\"page-label\">Page " + currentPage + "<div class=\"horizontal-line\"></div>" + "</div><div class=\"thoughts-page\">" + data + "</div>";
        thoughtsContainer.insertAdjacentHTML('beforeend', data);
        document.querySelector("#current-page").value = currentPage;
      }
    })
    .catch((error) => {
      console.error('Error loading more thoughts:', error);
    });
}

function initializeFunctions()
{
  // Action buttons (favorite, hide, spotlight, shadow)
  const actionButtons = document.querySelectorAll('.favorite, .hide, .spotlight, .shadow');
  actionButtons.forEach(function (button) {
    button.addEventListener('click', function (e) {
      e.preventDefault();
      actionButton(button);
    });
  });

  // Filter buttons
  const storageKey = 'selected_filter';
  const cookies = document.cookie.split(';');
  for (let i = 0; i < cookies.length; i++) {
    const cookie = cookies[i].trim();
    if (cookie.startsWith(storageKey + '=')) {
      applySelectedFilter(decodeURIComponent(cookie.substring(storageKey.length + 1)));
    }
  }

  // Pagination - load more thoughts when user scrolls to bottom of page
  // Has a 500 ms timeout
  window.addEventListener("scroll", () => {
    if (!throttleTimeout) {
      throttleTimeout = setTimeout(() => {
        throttleTimeout = null;
        if (window.innerHeight + window.scrollY + 10 >= document.querySelector('.thoughts').offsetHeight) {
          loadMoreThoughts();
        }
      }, 500);
    }
  });
}

let throttleTimeout;
initializeFunctions();
document.addEventListener('turbo:render', function() { initializeFunctions(); });