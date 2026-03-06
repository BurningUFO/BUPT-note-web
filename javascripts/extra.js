(() => {
  function showAll(items) {
    items.forEach((el) => el.classList.add("reveal-visible"));
    document.documentElement.classList.remove("motion-enabled");
  }

  function initReveal() {
    const items = Array.from(document.querySelectorAll(".reveal-on-scroll"));
    if (!items.length) {
      return;
    }

    const prefersReduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const supportsObserver = "IntersectionObserver" in window;

    if (prefersReduce || !supportsObserver) {
      showAll(items);
      return;
    }

    document.documentElement.classList.add("motion-enabled");
    items.forEach((el) => el.classList.remove("reveal-visible"));

    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            entry.target.classList.add("reveal-visible");
            observer.unobserve(entry.target);
          }
        }
      },
      { threshold: 0.15, rootMargin: "0px 0px -5% 0px" }
    );

    items.forEach((el) => observer.observe(el));
  }

  if (window.document$ && typeof window.document$.subscribe === "function") {
    window.document$.subscribe(initReveal);
  } else if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initReveal);
  } else {
    initReveal();
  }
})();
