class Memory {
  static const operations = const ['%', '/', 'x', '-', '+', '='];

  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  String _operation;
  String _value = '0';
  bool _wipeValue = false;
  String _lasCommand;

  void apllyCommand(String command){
    if(_isReplacingOperation(command)){
      _operation = command;
      return;
    }

    if(command == 'AC'){
      _allClear(); //Chamando metodo Clear
    } else if(operations.contains(command)){
      _setOperation(command); //setando nova Operação
    }
    else{
      _addDigit(command);//Adicionando Digito
    }

    _lasCommand = command;
  }

  _isReplacingOperation(String command){
    return operations.contains(_lasCommand)
      && operations.contains(command)
      && _lasCommand != '='
      && command != '=';
  }

  _setOperation(String newOperation) {
    bool isEqualSign = newOperation == '='; //se o igual foi clicao atribuira isEqualSign 

    if(_bufferIndex == 0){//Se o indice do buffer for 0
      if(!isEqualSign){//Não clicado no "="
        _operation = newOperation;
        _bufferIndex = 1;
        _wipeValue = true;
      }
    } else{
      _buffer[0] = _calculate();
      _buffer[1] = 0.0;
      _value = _buffer[0].toString(); //resultado
      _value = _value.endsWith('.0') ? _value.split('.')[0] : _value;//Se o resultado for inteiro remove o ponto

      _operation = isEqualSign ? null : newOperation;//se o botao de igual for nul seta uma nova operação
      _bufferIndex = isEqualSign ? 0 : 1;//verificando o index e atribui a _bufferIndex
    }

      _wipeValue = true; //!isEqualSign;
  }

  _addDigit(String digit) {
    final isDot = digit == '.';
    final wipeValue = (_value == '0' && !isDot) || _wipeValue;//substitui o valor atual de zero po um numero se o prximo digito é != '.' 

    if(isDot && _value.contains('.') && !wipeValue){//Verificando se o ponto ja foi diitado uma vez, e a operacao nao foi "inicializada"
      return;
    }

    final empityValue = isDot ? '0' : '';//se digitar ponto antes de qualquer numero, acrescenta o zero antes
    final currentValue = wipeValue ? empityValue : _value;
    
    _value = currentValue + digit;
    _wipeValue = false; 

    _buffer[_bufferIndex] = double.tryParse(_value) ?? '0';
  }

  _allClear() {
    _value = '0';
    _buffer.setAll(0, [0.0, 0.0]); //Zerando os valores do buffer
    _operation = null;
    _bufferIndex = 0;
    _wipeValue = false;
  }

  _calculate(){
    switch(_operation){
      case '%': return _buffer[0] % _buffer[1];
      case '/': return _buffer[0] / _buffer[1];
      case 'x': return _buffer[0] * _buffer[1];
      case '-': return _buffer[0] - _buffer[1];
      case '+': return _buffer[0] + _buffer[1];
      default: return _buffer[0];
    }
  }

  String get value {
    return _value;
  }
}