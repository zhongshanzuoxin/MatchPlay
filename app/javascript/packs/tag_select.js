  document.addEventListener('turbolinks:load', function() {
    const tagSelects = document.querySelectorAll(".form-select[name^='group[tag_ids]']");

    tagSelects.forEach(function(select, index) {
      select.addEventListener("change", function() {
        const selectedValues = Array.from(tagSelects)
          .map(function(tagSelect) {
            return tagSelect.value;
          })
          .filter(function(value) {
            return value !== ""; // 空の選択を除外
          });

        if (selectedValues.length !== new Set(selectedValues).size) {
          // 選択した値に重複がある場合
          alert("同じタグを複数選択することはできません");
          this.value = ""; // 選択をクリア
        }
      });
    });
  });
  