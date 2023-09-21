export default {
  data() {
    return {
      card: {
        sm: 6,
        md: 4,
        lg: 4,
        xl: 3,
        height: 180,
        elevation: 12,
      },
      images: [
        require('@/assets/images/sample_images/pc.jpeg'),
        require('@/assets/images/sample_images/talking.jpeg'),
        require('@/assets/images/sample_images/buisiness.jpeg'),
        require('@/assets/images/sample_images/heart.jpeg'),
        require('@/assets/images/sample_images/academy.jpeg'),
        require('@/assets/images/sample_images/house.jpeg'),
        require('@/assets/images/sample_images/books.jpeg'),
        require('@/assets/images/sample_images/designing.jpeg'),
      ],
      heartColor: 'white',
    };
  },
};
