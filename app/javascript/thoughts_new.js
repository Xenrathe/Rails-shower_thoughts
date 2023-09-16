document.addEventListener('DOMContentLoaded', function() {
  const textarea = document.querySelector('.thoughts-new .content-input');
  const characterCount = document.getElementById('content-char-count');

  textarea.addEventListener('input', function() {
    const currentLength = textarea.value.length;
    const maxLength = textarea.getAttribute('maxlength');
    const remainingCharacters = maxLength - currentLength;

    characterCount.textContent = remainingCharacters + " characters remaining";
  });
});