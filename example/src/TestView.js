import React, {useRef, useState} from 'react';
import { Image, Button, StyleSheet } from 'react-native';

const TestView = () => {
    return (
        <>
            <Button 
                title='Choose Image' 
                onPress={() => {
                    console.log('Choose image');
                }}>
            </Button>
        </>
    );
};

export default TestView;
