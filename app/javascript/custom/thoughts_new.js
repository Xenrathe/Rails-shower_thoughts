function initializeFunctions()
{
  // Do not try to make textarea, titlearea, etc global:
  // They have to be re-initialized every time page loads
  // That's because if there's an error on the form, the page deletes the form and
  // recreates it in order to wrap an error div around it

  //textarea (content) stuffs
  const textarea = document.getElementById('thought_content');
  if (textarea === null)
    return;

  updateContent();
  textarea.addEventListener('input', function() { updateContent(); });

  //title stuffs
  const titlearea = document.querySelector('.title-input');
  updateTitle();
  titlearea.addEventListener('input', function() { updateTitle(); });

  //update Countdown stuffs
  if (document.getElementById('countdown-timer') !== null)
  {
    setInterval(updateCountdown, 1000);
    window.addEventListener('DOMContentLoaded', updateCountdown);
  }
}

function updateContent()
{
  const content = document.getElementById('thought_content');
  const characterCount = document.getElementById('content-char-count');

  const currentLength = content.value.length;
  const maxLength = content.getAttribute('maxlength');
  const minLength = content.getAttribute('minlength');
  const remainingCharacters = maxLength - currentLength;

  if (currentLength >= minLength){
    characterCount.textContent = remainingCharacters + " characters remaining";
    characterCount.style.color = 'black';
  }
  else {
    characterCount.textContent = minLength + " character minimum";
    characterCount.style.color = 'red';
  }
  checkSubmitButton();
}

function updateTitle()
{
  const title = document.querySelector('.title-input');
  const titleWarning = document.getElementById('title-warning');

  const currentLength = title.value.length;
  const minLength = title.getAttribute('minlength');

  if (currentLength >= minLength){
    titleWarning.style.opacity = 0;
  }
  else{
    titleWarning.style.opacity = 1;
    titleWarning.textContent = minLength + " character minimum";
  }
  checkSubmitButton();
}

function checkSubmitButton()
{
  const submitButton = document.getElementById('submit-button');

  if (submitButton === null)
    return;

  const title = document.querySelector('.title-input');
  const titleCurrentLength = title.value.length;
  const titleMinLength = title.getAttribute('minlength');

  const content = document.getElementById('thought_content')
  const contentcurrentLength = content.value.length;
  const contentMinLength = content.getAttribute('minlength');

  if (titleCurrentLength >= titleMinLength && contentcurrentLength >= contentMinLength){
    submitButton.disabled = false;
    if (submitButton.classList.contains('btn-disabled')){
      submitButton.classList.add('btn-enabled');
      submitButton.classList.remove('btn-disabled')
    }
  }
  else {
    submitButton.disabled = true;
    if (submitButton.classList.contains('btn-enabled')){
      submitButton.classList.add('btn-disabled');
      submitButton.classList.remove('btn-enabled')
    }
  }
}

function updateCountdown() {
  const deadlineElement = document.querySelector("#deadline-date");
  if (deadlineElement === null)
    return;
  
  const now = new Date();
  const deadline = new Date(deadlineElement.value + 'Z');
  const timeRemaining = (deadline - now ) / 1000;

  if (timeRemaining <= 0) {
    const submitButton = document.getElementById('submit-button');
    submitButton.disabled = true;
    if (submitButton.classList.contains('btn-enabled')){
      submitButton.classList.add('btn-disabled');
      submitButton.classList.remove('btn-enabled')
    }
    document.getElementById('countdown-timer').textContent = "Editing deadlined passed.";
  }
  else {
    const minutes = Math.floor(timeRemaining / 60);
    const seconds = Math.floor(timeRemaining % 60);
    document.getElementById('countdown-timer').textContent = `${minutes} minutes, ${seconds} seconds remaining to edit`;
  }
}

initializeFunctions();
document.addEventListener('turbo:render', function() { initializeFunctions(); });
