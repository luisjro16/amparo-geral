import React from "react"
import {
    Text,
    View,
    Image,
    TextInput,
    TouchableOpacity
} from 'react-native'
import {style} from './style'
import LogoAmparo from '../../assets/LogoAmparo.png'
import AntDesign from '@expo/vector-icons/AntDesign'
import Entypo from '@expo/vector-icons/Entypo'

export default function Login () {
    return (
        <View style={style.container}>
            <View style={style.boxTop}>
                <Image 
                    style={style.logo} 
                    source={LogoAmparo}
                    resizeMode="contain"
                />
            </View>

            <View style={style.boxMid}>
                <Text style={style.textTitle}>NOME DE USUÁRIO</Text>
                <View style={style.boxInput}>
                    <TextInput style={style.textInput}/>
                    <AntDesign
                        name='user'
                        size={24}
                        color='black'
                    />
                </View>

                <Text style={style.textTitle}>SENHA</Text>
                <View style={style.boxInput}>
                    <TextInput style={style.textInput}/>
                    <Entypo 
                        name="eye" 
                        size={24} 
                        color="black" 
                    />
                </View>
                <Text style={style.textForget}>Esqueci minha senha</Text>
            </View>

            <View style={style.boxBottom}>
                <TouchableOpacity style={style.button}>
                    <Text style={style.textButton}>Entrar</Text>
                </TouchableOpacity>
            </View>

            <Text style={style.textBotton}>Não tem conta? Criar agora!</Text>
        </View>
    )
}

