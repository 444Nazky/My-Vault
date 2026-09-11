# React Native Task Manager - Animations

## Overview
Animation techniques for React Native Task Manager app.

## React Native Animation APIs
- Animated API
- Reanimated
- Lottie

## Basic Animation
```javascript
import { Animated, Text, View } from 'react-native';

const fadeAnim = new Animated.Value(0);

Animated.timing(fadeAnim, {
  toValue: 1,
  duration: 1000,
  useNativeDriver: true,
}).start();
```

## Common Animations
- Fade in/out
- Slide in/out
- Scale
- Rotation

## Tags
 #frontend
