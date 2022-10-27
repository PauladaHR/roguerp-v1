const axios = require('axios');
const config = require('../config');
const { Wait, relativeEvent, SQLdate } = require('../lib/utils');
const net_events = require('../net_events');

class DeliveryController {
  constructor(server_identifier, client_domain, verify_timeout, api_protocol) {
    this.server_identifier = server_identifier;
    this.client_domain = client_domain;
    this.verify_timeout = verify_timeout;
    this.api_protocol = api_protocol;
  }

  startThread() {
    let loggedError = false;

    const tick = setTick(async () => {
      axios.default
        .get(`${this.api_protocol}://${this.client_domain}/api/entregas`, {
          headers: {
            Authorization: `Bearer ${this.server_identifier}`,
          },
        })
        .then(async (response) => {
          const deliveries = response.data;
          const productsSuccessDelivered = [];

          let finished;

          for (const delivery of deliveries) {
            const { id, client_id, status } = delivery;

            for (const product of delivery.products) {
              const { id: productId, name, configs, quantity } = product;

              let logged;

              for (let i = 0; i < quantity; i++) {
                for (const config of configs) {
                  const { value, amount } = config;

                  finished = false;

                  if (config.command === 'JS_CODE') {
                    try {
                      await eval(value);

                      productsSuccessDelivered.push(productId);

                      if (!logged) {
                        logged = true;
                        this.successDelivered(name, client_id, id);
                      }
                    } catch (err) {
                      console.log(
                        `^3[CENTRALCART] Ocorreu um erro ao executar o código JS '${value}'.^0`,
                        err.toString()
                      );
                    }

                    finished = true;
                    continue;
                  }

                  if (config.command === 'SQL_CODE') {
                    try {
                      emit(
                        'fxserver-events-customSQL',
                        value,
                        client_id,
                        (success) => {
                          if (success) {
                            productsSuccessDelivered.push(productId);

                            if (!logged) {
                              logged = true;

                              if (success) {
                                this.successDelivered(name, client_id, id);
                              } else {
                                console.log(
                                  `^5[ENTREGA #${id}] [${name} para #${client_id}] => ^3`,
                                  'Ocorreu um erro durante a entrega. Solicite suporte com a nossa equipe.',
                                  '^0'
                                );
                              }
                            }
                          }
                        }
                      );
                    } catch (err) {
                      console.log(
                        `^3[CENTRALCART] Ocorreu um erro ao executar o código JS '${value}'.^0`,
                        err
                      );
                    }

                    finished = true;
                    continue;
                  }

                  emit(
                    net_events[config.command],
                    client_id,
                    value || '',
                    amount || 1,
                    (success) => {
                      if (success) {
                        productsSuccessDelivered.push(productId);

                        if (config.schedule && config.schedule > 0) {
                          var date = new Date();
                          date.setDate(date.getDate() + config.schedule);

                          const command = relativeEvent(config.command);

                          emit(
                            'fxserver-events-addRemoval',
                            client_id,
                            command,
                            value,
                            SQLdate(date, config.schedule)
                          );
                        }

                        if (!logged) {
                          logged = true;

                          if (success) {
                            this.successDelivered(name, client_id, id);
                          } else {
                            console.log(
                              `^5[ENTREGA #${id}] [${name} para #${client_id}] => ^3`,
                              'Ocorreu um erro durante a entrega. Solicite suporte com a nossa equipe.^0'
                            );
                          }
                        }
                      }
                      finished = true;
                    }
                  );
                }
              }
            }
          }

          await this.until(() => finished === true);

          axios.default.post(
            `${this.api_protocol}://${this.client_domain}/api/entregas/`,
            { items: productsSuccessDelivered },
            {
              headers: {
                Authorization: `Bearer ${this.server_identifier}`,
              },
            }
          );
        })
        .catch((err) => {
          if (loggedError) return;

          loggedError = true;

          if (err.response) {
            //clearTick(tick);

            switch (err.response.status) {
              case 404:
                console.log(
                  '^3[CENTRALCART] Nao foi possivel conectar com a API. Verifique se os dados informados na configuracao estao corretos.^0'
                );
                return;

              case 402:
                console.log(
                  '^3[CENTRALCART] Sua loja foi suspensa por atraso no pagamento. Acesse centralcart.com.br/app para normalizar a situação.^0'
                );
                return;

              case 401:
                console.log(
                  '^3[CENTRALCART] Nao foi possivel conectar com a API. Nao foi possivel validar o token de acesso.^0'
                );
                return;

              default:
                console.log(
                  '^3[CENTRALCART] Ocorreu um erro ao conectar com a API. Cód.' +
                    err.response.status +
                    '. Tentando reconectar...^0'
                );
                return;
            }
          }

          console.log(
            '^3[CENTRALCART] Ocorreu um erro ao conectar com a API. Tentando reconectar...^0',
            err.toString()
          );
        });

      await Wait(this.verify_timeout);
    });
  }

  banner() {
    console.log(
      Buffer.from(
        'XjMKICAgX19fX19fICAgICAgICAgICAgICAgICBfXyAgICAgICAgICAgICAgICAgICAgIF9fICAgX19fX19fICAgICAgICAgICAgICAgICAgIF9fIAogIC8gX19fXy8gIF9fXyAgICBfX19fICAgLyAvXyAgIF9fX19fICBfX19fIF8gICAvIC8gIC8gX19fXy8gIF9fX18gXyAgIF9fX19fICAvIC9fCiAvIC8gICAgICAvIF8gXCAgLyBfXyBcIC8gX18vICAvIF9fXy8gLyBfXyBgLyAgLyAvICAvIC8gICAgICAvIF9fIGAvICAvIF9fXy8gLyBfXy8KLyAvX19fICAgLyAgX18vIC8gLyAvIC8vIC9fICAgLyAvICAgIC8gL18vIC8gIC8gLyAgLyAvX19fICAgLyAvXy8gLyAgLyAvICAgIC8gL18gIApcX19fXy8gICBcX19fLyAvXy8gL18vIFxfXy8gIC9fLyAgICAgXF9fLF8vICAvXy8gICBcX19fXy8gICBcX18sXy8gIC9fLyAgICAgXF9fLyAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgIHd3dy5jZW50cmFsY2FydC5jb20uYnIgLSB2MS4wLjMKICAgICAgICAgICAgICAgICAgICAgTW9uZXRpemUgbyBzZXUgc2Vydmlkb3IgZGUgRml2ZU0hCl4w',
        'base64'
      ).toString()
    );
  }

  until(conditionFunction) {
    const poll = (resolve) => {
      if (conditionFunction()) resolve();
      else setTimeout((_) => poll(resolve), 400);
    };

    return new Promise(poll);
  }

  successDelivered(name, client_id, id) {
    console.log(
      `^5[ENTREGA] [${name} para #${client_id}] [${id}] => ^3`,
      'Entrega concluída.',
      '^0'
    );

    emit('fxserver_events:user-notify', client_id, name);
    emit('fxserver_events:global_chat_message', client_id, name);
  }
}

module.exports = DeliveryController;
