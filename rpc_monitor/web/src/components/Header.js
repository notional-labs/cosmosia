import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { Link, withRouter } from 'react-router-dom';

class Header extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      username: '',
      block_num: '',
    }
  };

  render() {
    return (
      <header className="Topnav">
        <div className="navbar navbar-dark">
          <a className="brand" href="###">
            <span className="sitename">RPC Monitor</span>
          </a>
          <nav className="top-menu">
            <Link to='/test' style={{lineHeight: '32px', color: 'white'}}>Test</Link>
          </nav>
        </div>
      </header>
    )
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    dispatch,
  };
};

const withConnect = connect(
  null,
  mapDispatchToProps,
);

export default compose(withRouter, withConnect)(Header);
