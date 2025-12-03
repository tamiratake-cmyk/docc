import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_bloc.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_event.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_state.dart';
import  'package:flutter_application_1/app/theme/app_theme.dart';
import 'package:flutter_application_1/domain/entities/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SettingPage extends StatelessWidget {

  const SettingPage({super.key});

  @override
  Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: const Text('Settings'),
    ),
    body: BlocBuilder<ThemeBloc, ThemeState>(
       builder: (context, state) => 
        Padding(
          padding: const EdgeInsets.all(45.0),
          child: 
          Column(
            children: [
              Text('Select App Theme'),
              SizedBox(height: 20),
            DropdownButton<AppThemeMode>(
              style: Theme.of(context).textTheme.titleMedium,
              value: state.theme,
              items: const [
                 DropdownMenuItem(child:Text('Light Theme', ), value: AppThemeMode.light),
                  DropdownMenuItem(child:Text('Dark Theme'), value: AppThemeMode.dark),
                  DropdownMenuItem(child: Text('System Theme'), value: AppThemeMode.system),
                  ],
                onChanged: (value)=>context.read<ThemeBloc>().add(ChangeTheme(value!)),
             ),
            ]
          )
        )
    )
  );
    
  }

}