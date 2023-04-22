import React, { useEffect, useState } from "react";
import { Text, Button, Image, Alert } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import TestView from "./src/TestView";

const Stack = createNativeStackNavigator();
const navigationRef = React.createRef();

const App = () => {
  return (
    <NavigationContainer ref={navigationRef}>
      <Stack.Navigator>
        <Stack.Screen name="Home" component={HomeScreen} options={{ title: 'Photo Editor View' }} />
        <Stack.Screen name="TestView" component={TestView} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

const HomeScreen = ({ navigation }) => {
  return (
    <>
      <Button title="TestView" onPress={() => navigation.navigate('TestView', {})} />
    </>
  );
};

export default App;