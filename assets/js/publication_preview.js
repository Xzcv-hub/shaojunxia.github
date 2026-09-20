(function () {
    const covers = document.querySelectorAll('.publication-cover');
    if (!covers.length) return;

    const preview = document.createElement('div');
    preview.className = 'publication-image-preview';
    preview.hidden = true;
    preview.setAttribute('aria-hidden', 'true');
    const image = document.createElement('img');
    image.alt = '';
    preview.appendChild(image);
    document.body.appendChild(preview);

    const canHover = window.matchMedia('(hover: hover) and (pointer: fine)');
    let activeCover = null;

    function hide() {
        activeCover = null;
        preview.hidden = true;
    }

    function show(cover) {
        activeCover = cover;
        preview.hidden = true;
        image.src = cover.href;
        if (image.complete && image.naturalWidth > 0) preview.hidden = false;
    }

    image.addEventListener('load', function () {
        if (activeCover && image.src === activeCover.href) preview.hidden = false;
    });
    image.addEventListener('error', hide);

    covers.forEach(function (cover) {
        cover.addEventListener('pointerenter', function (event) {
            if (canHover.matches && event.pointerType !== 'touch') show(cover);
        });
        cover.addEventListener('pointerleave', function () {
            if (activeCover === cover && !cover.matches(':focus-visible')) hide();
        });
        cover.addEventListener('focus', function () {
            if (cover.matches(':focus-visible')) show(cover);
        });
        cover.addEventListener('blur', function () {
            if (activeCover === cover) hide();
        });
        cover.addEventListener('click', hide);
    });

    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') hide();
    });
    window.addEventListener('scroll', hide, { passive: true });
    window.addEventListener('resize', hide);
})();
