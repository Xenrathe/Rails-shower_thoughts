

function updateCharacterCount()
{
  const textarea = document.getElementById('thought_content');
  const characterCount = document.getElementById('content-char-count');
  const startingCharacters = textarea.getAttribute('maxlength') - textarea.value.length;
  characterCount.textContent =  startingCharacters + " characters remaining";

  textarea.addEventListener('input', function() {
  const currentLength = textarea.value.length;
  const maxLength = textarea.getAttribute('maxlength');
  const remainingCharacters = maxLength - currentLength;

  characterCount.textContent = remainingCharacters + " characters remaining";
  });
}

updateCharacterCount();
document.addEventListener('turbo:render', function() { updateCharacterCount(); });
