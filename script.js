// Navbar Scroll Effect
window.addEventListener('scroll', () => {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.style.padding = '0.5rem 5%';
        navbar.style.background = 'rgba(15, 16, 20, 0.95)';
    } else {
        navbar.style.padding = '1rem 5%';
        navbar.style.background = 'rgba(15, 16, 20, 0.8)';
    }
});

// Mobile Menu Toggle
const hamburger = document.querySelector('.hamburger');
const navLinks = document.querySelector('.nav-links');

hamburger.addEventListener('click', () => {
    navLinks.classList.toggle('nav-active');
});

// Close menu when a link is clicked
const navItems = document.querySelectorAll('.nav-links li a');
navItems.forEach(item => {
    item.addEventListener('click', () => {
        navLinks.classList.remove('nav-active');
    });
});



// Reveal Elements on Scroll
const revealElements = document.querySelectorAll('.gallery-item, .vibe-text, .contact-container');

const revealOnScroll = () => {
    const windowHeight = window.innerHeight;
    const elementVisible = 150;

    revealElements.forEach((el) => {
        const elementTop = el.getBoundingClientRect().top;
        if (elementTop < windowHeight - elementVisible) {
            el.style.opacity = '1';
            el.style.transform = 'translateY(0)';
            el.style.transition = 'all 0.8s ease-out';
        } else if (!el.style.opacity) {
            el.style.opacity = '0';
            el.style.transform = 'translateY(50px)';
        }
    });
};

window.addEventListener('scroll', revealOnScroll);
// Trigger once on load
revealOnScroll();

// Banner Image Slider (Fade and Scale Effect)
const bannerImages = document.querySelectorAll('.hero-bg img');
let currentImageIndex = 0;

function rotateBanner() {
    if (bannerImages.length <= 1) return;
    
    const nextIndex = (currentImageIndex + 1) % bannerImages.length;
    
    // Remove states from all images first
    bannerImages.forEach(img => {
        img.classList.remove('active', 'prev');
    });
    
    // Set classes for smooth transition
    bannerImages[currentImageIndex].classList.add('prev');
    bannerImages[nextIndex].classList.add('active');
    
    currentImageIndex = nextIndex;
}

if (bannerImages.length > 0) {
    // Ensure the first image is active on start
    bannerImages[0].classList.add('active');
    if (bannerImages.length > 1) {
        setInterval(rotateBanner, 5000); // Change image every 5 seconds
    }
}
